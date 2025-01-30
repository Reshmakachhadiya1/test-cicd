package org.example;

import io.quarkus.qute.Template;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/hello")
public class GreetingResource {

    @Inject
    Template hello; // Inject the Qute template

    @GET
    @Produces(MediaType.TEXT_HTML) // Ensure correct content type
    public String getGreeting() {
        return hello.data("name", "Test CI CD Pipeline with TekTok").render(); // Render the template
    }
}