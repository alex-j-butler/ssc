module web.controller.bookings;
import web.controller;

import std.conv;
import std.datetime;

import store;
import models;

@path("/controller/bookings")
class BookingsInterface {
    mixin WebInterface;

    Booking booking;

    protected void requireBooking(scope HTTPServerRequest req) {
        auto server = Server.get(req.params["server"]);
        booking = Booking.bookingFor(cast(Server)server);
        enforceHTTP(booking !is null, HTTPStatus.notFound);
    }

    @path("")
    void postCreate(scope HTTPServerRequest req, string user, ushort duration) {
        requireAuthentication(req);

        try {
            Booking.create(client, user, duration.dur!"hours");
        } catch (StoreException e) {
            enforceHTTP(false, HTTPStatus.conflict, "Duplicate client/user");
        }
        emptyResponse;
    }

    @path("/:server/delete")
    void postDelete(scope HTTPServerRequest req) {
        requireAuthentication(req);
        requireBooking(req);

        booking.end();
        emptyResponse;
    }
}
