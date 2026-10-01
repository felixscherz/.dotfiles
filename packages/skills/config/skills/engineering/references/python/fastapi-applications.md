---
name: fastapi-applications
description: Apply when designing or changing a Python FastAPI application, especially its domain boundaries, routes, dependency injection, request and response models, or application wiring.
---

# FastAPI applications

Use these patterns where the project does not already have a suitable convention. Organize code by domain or feature;
do not require a particular directory layout. The important distinction is between adapters, use cases, focused domain
behavior, and infrastructure, not the directory names.

## Keep the domain independent

- Express domain concepts with the domain's vocabulary. Use immutable value objects for meaningful IDs and constrained
  values, and plain Python entities and services for business behavior. Keep FastAPI, `Depends`, Pydantic transport
  DTOs, HTTP exceptions, database documents, and framework state out of domain code and use cases.
- Put cross-domain sequencing, failure policy, and transaction ownership in a use case named for the intent. Keep
  focused rules and invariants in domain objects or services. A service should not acquire several other services simply
  because an entry point needs a workflow; see `../domain-driven-design.md`. Do not wrap every simple operation in a
  pass-through use case.
- Convert primitives and DTOs to domain types at input boundaries, and convert domain results to response DTOs at output
  boundaries. Map persistence shapes separately; an HTTP schema or database document need not become the domain model.
- Raise domain or use-case failures without HTTP dependencies. Translate them to status codes and response shapes at the
  HTTP boundary. Keep async I/O async; do not block the event loop.

## Inject ports through narrow Protocols

Define each port close to the use case or service that consumes it, with only the operations that consumer needs. Type
constructors against those ports rather than concrete repositories, other full-service interfaces, or HTTP clients. A
port can represent a repository, an external lookup, an event publisher, or a callable operation. The application
container supplies concrete implementations.

```python
from dataclasses import dataclass
from typing import Protocol


@dataclass(frozen=True)
class BookingId:
    value: str


class InvalidGuestError(Exception): ...


@dataclass(frozen=True)
class GuestName:
    value: str

    def __post_init__(self) -> None:
        if not self.value.strip():
            raise InvalidGuestError("Guest name is required")


@dataclass(frozen=True)
class Booking:
    id: BookingId
    guest: GuestName


class BookingRepository(Protocol):
    async def save(self, booking: Booking) -> None: ...


class ReserveBookingId(Protocol):
    async def __call__(self) -> BookingId: ...


class BookingService:
    def create(self, booking_id: BookingId, guest: GuestName) -> Booking:
        return Booking(id=booking_id, guest=guest)


class CreateBooking:
    def __init__(
        self, repository: BookingRepository, reserve_id: ReserveBookingId, bookings: BookingService
    ) -> None:
        self._repository = repository
        self._reserve_id = reserve_id
        self._bookings = bookings

    async def execute(self, guest: GuestName) -> Booking:
        booking = self._bookings.create(await self._reserve_id(), guest)
        await self._repository.save(booking)
        return booking
```

Use real implementations at runtime and small fakes or stubs in use-case tests. Protocols describe capabilities; they
do not require inheritance or a general-purpose DI framework. If a workflow spans several writes or external effects,
decide what commits together and what happens on partial failure before moving it. Extraction alone does not make a
workflow atomic.

## Make HTTP handlers adapters

Use `Annotated[UseCase, Depends(provider)]` for a handler implementing a use case. The provider obtains it from the
application container rather than constructing repositories or workflows per request. Keep handlers focused on parsing,
domain conversion, invoking one use case, error translation, and response mapping. Two routes for the same intent can
call the same use case with different domain inputs; neither route should coordinate several services. Existing simple
operations need not be wrapped solely to satisfy a naming convention.

```python
from typing import Annotated, cast

from fastapi import APIRouter, Depends, HTTPException, Request, status
from pydantic import BaseModel

# Import CreateBooking, GuestName, InvalidGuestError, and Container from their respective modules.
router = APIRouter(prefix="/bookings")


class CreateBookingRequest(BaseModel):
    guest: str


class BookingResponse(BaseModel):
    id: str
    guest: str


def get_container(request: Request) -> Container:
    return cast(Container, request.app.state.container)


def get_create_booking(container: Annotated[Container, Depends(get_container)]) -> CreateBooking:
    return container.create_booking


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_booking(
    request: CreateBookingRequest,
    create_booking: Annotated[CreateBooking, Depends(get_create_booking)],
) -> BookingResponse:
    try:
        guest = GuestName(request.guest)
    except InvalidGuestError as exc:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=str(exc)) from exc
    booking = await create_booking.execute(guest)
    return BookingResponse(id=booking.id.value, guest=booking.guest.value)
```

For route tests, override `get_create_booking` through `app.dependency_overrides` and check the HTTP contract without
starting real infrastructure. Test the use case through `execute()` with fakes for its ports. Test focused domain
behavior without involving FastAPI.

## Compose once at the application boundary

Keep construction in a single composition root, for example a `Container` with `@cached_property` providers for shared
settings, clients, repositories, services, and use cases. Providers make the dependency graph explicit. Share a
container per app/process, not per request; do not use process-scoped instances for mutable request-specific state. Use
local imports in providers only when needed to break import cycles.

Construct the container at bootstrap (or in the app factory), attach it to `app.state`, and use FastAPI lifespan for
starting and stopping resources such as database clients, message consumers, and background work. Non-HTTP entry points
use the same composition root directly, not FastAPI dependency resolution. Allow a container to be supplied to the app
factory in tests. Keep FastAPI `Depends` and `Request` out of the container, use cases, and services.

```python
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from functools import cached_property

from fastapi import FastAPI


class Container:
    def __init__(self, database: Database) -> None:
        self.database = database

    @cached_property
    def booking_repository(self) -> BookingRepository:
        return SqlBookingRepository(self.database)

    @cached_property
    def reserve_booking_id(self) -> ReserveBookingId:
        return DatabaseBookingIdReserver(self.database)

    @cached_property
    def booking_service(self) -> BookingService:
        return BookingService()

    @cached_property
    def create_booking(self) -> CreateBooking:
        return CreateBooking(self.booking_repository, self.reserve_booking_id, self.booking_service)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    container: Container = app.state.container
    await container.database.connect()
    try:
        yield
    finally:
        await container.database.close()


def create_app(container: Container) -> FastAPI:
    app = FastAPI(lifespan=lifespan)
    app.state.container = container
    app.include_router(router)
    return app
```

The infrastructure adapter classes in this sketch are application-specific; construct `Container` with configured
infrastructure at startup. Cache long-lived dependencies deliberately; manage request/transaction-scoped dependencies
separately. Check the existing project's OpenAPI contract and test conventions when changing routes or DTOs.
