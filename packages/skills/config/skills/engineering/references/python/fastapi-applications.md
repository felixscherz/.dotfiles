---
name: fastapi-applications
description: Apply when designing or changing a Python FastAPI application, especially its domain boundaries, routes, dependency injection, request and response models, or application wiring.
---

# FastAPI applications

Use these patterns where the project does not already have a suitable convention. Organize code by domain or feature; do not require an `api/model/control` package split. The important boundary is between domain behavior, transport, and infrastructure, not the directory names.

## Keep the domain independent

- Express domain concepts with the domain's vocabulary. Use immutable value objects for meaningful IDs and constrained values, and plain Python entities and services for business behavior. Keep FastAPI, `Depends`, Pydantic transport DTOs, HTTP exceptions, database documents, and framework state out of domain code.
- A service implements a use case and coordinates the work needed for it. Put decisions and invariants there or in domain objects, not in the route. Services may do I/O through injected ports without depending on the framework.
- Convert primitives and DTOs to domain types at input boundaries, and convert domain results to response DTOs at output boundaries. Map persistence shapes separately; an HTTP schema or database document need not become the domain model.
- Raise domain-specific failures from services. Translate them to status codes and response shapes at the HTTP boundary. Keep async I/O async; do not block the event loop.

## Inject ports through narrow Protocols

Define each port close to the service that needs it, with only the operations that service uses. Type service constructors against those ports, not against concrete repositories or HTTP clients. A port can represent a repository, an external lookup, an event publisher, or a callable operation. Concrete implementations live at infrastructure boundaries and are supplied by the application container.

```python
from dataclasses import dataclass
from typing import Protocol


@dataclass(frozen=True)
class BookingId:
    value: str


@dataclass(frozen=True)
class Booking:
    id: BookingId
    guest: str


class BookingRepository(Protocol):
    async def save(self, booking: Booking) -> None: ...


class ReserveBookingId(Protocol):
    async def __call__(self) -> BookingId: ...


class BookingService:
    def __init__(self, repository: BookingRepository, reserve_id: ReserveBookingId) -> None:
        self._repository = repository
        self._reserve_id = reserve_id

    async def create(self, guest: str) -> Booking:
        booking = Booking(id=await self._reserve_id(), guest=guest)
        await self._repository.save(booking)
        return booking
```

Use real implementations at runtime and small fakes or stubs in service tests. Protocols describe capabilities; they do not require inheritance or a general-purpose DI framework.

## Make HTTP handlers adapters

Use `Annotated[Service, Depends(provider)]` for dependencies in handler signatures. A provider obtains the service from the application container; it should not construct a repository or recreate the service for each request. Keep handlers focused on parsing, domain conversion, invoking the service, error translation, and response mapping.

```python
from typing import Annotated, cast

from fastapi import APIRouter, Depends, Request, status
from pydantic import BaseModel

# Import BookingService and Container from their respective modules.
router = APIRouter(prefix="/bookings")


class CreateBookingRequest(BaseModel):
    guest: str


class BookingResponse(BaseModel):
    id: str
    guest: str


def get_container(request: Request) -> Container:
    return cast(Container, request.app.state.container)


def get_booking_service(container: Annotated[Container, Depends(get_container)]) -> BookingService:
    return container.booking_service


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_booking(
    request: CreateBookingRequest,
    service: Annotated[BookingService, Depends(get_booking_service)],
) -> BookingResponse:
    booking = await service.create(request.guest)
    return BookingResponse(id=booking.id.value, guest=booking.guest)
```

For tests of a route, override `get_booking_service` through `app.dependency_overrides` and check the HTTP contract without starting real infrastructure. Test service behavior separately with fakes implementing its ports.

## Compose once at the application boundary

Keep construction in a single composition root, for example a `Container` with `@cached_property` providers for shared settings, clients, repositories, and services. Providers make the dependency graph explicit: a service receives concrete adapters for its Protocol ports. Share a container per app/process, not per request; don't use process-scoped instances for mutable request-specific state. Use local imports in providers only when needed to break import cycles.

Construct the container at bootstrap (or in the app factory), attach it to `app.state`, and use FastAPI lifespan for starting and stopping resources such as database clients, message consumers, and background work. Non-HTTP entry points (workers, CLI, message handlers) use the same composition root directly, not FastAPI dependency resolution. Allow a container to be supplied to the app factory in tests. Keep FastAPI `Depends` and `Request` out of the container and services.

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
        return BookingService(self.booking_repository, self.reserve_booking_id)


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

The infrastructure adapter classes in this sketch are application-specific; construct `Container` with configured infrastructure at startup. Cache long-lived dependencies deliberately; manage request/transaction-scoped dependencies separately. Check the existing project's OpenAPI contract and test conventions when changing routes or DTOs.
