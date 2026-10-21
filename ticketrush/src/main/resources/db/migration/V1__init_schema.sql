CREATE TABLE users (
    id            BIGSERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL,          -- USER, ORGANIZER, ADMIN
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE events (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    venue       VARCHAR(255) NOT NULL,
    starts_at   TIMESTAMPTZ  NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_by  BIGINT       NOT NULL REFERENCES users(id),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE bookings (
    id          UUID PRIMARY KEY,
    user_id     BIGINT      NOT NULL REFERENCES users(id),
    event_id    BIGINT      NOT NULL REFERENCES events(id),
    status      VARCHAR(20) NOT NULL,   -- HELD, PAYMENT_PENDING, CONFIRMED, EXPIRED, FAILED
    total_paise BIGINT      NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE event_seats (
    id              BIGSERIAL PRIMARY KEY,
    event_id        BIGINT      NOT NULL REFERENCES events(id),
    seat_label      VARCHAR(20) NOT NULL,       -- e.g. A1, A2
    price_paise     BIGINT      NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',  -- AVAILABLE, HELD, BOOKED
    booking_id      UUID REFERENCES bookings(id),
    hold_expires_at TIMESTAMPTZ,
    version         BIGINT      NOT NULL DEFAULT 0,
    UNIQUE (event_id, seat_label)
);

CREATE TABLE payments (
    id              UUID PRIMARY KEY,
    booking_id      UUID        NOT NULL REFERENCES bookings(id),
    idempotency_key VARCHAR(100) NOT NULL UNIQUE,
    amount_paise    BIGINT      NOT NULL,
    status          VARCHAR(20) NOT NULL,       -- PENDING, SUCCESS, FAILED
    provider_ref    VARCHAR(100),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_event_seats_event_status ON event_seats(event_id, status);
CREATE INDEX idx_bookings_status_expiry ON bookings(status, expires_at);