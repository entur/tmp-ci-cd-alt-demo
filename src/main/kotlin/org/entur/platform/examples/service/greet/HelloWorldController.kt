package org.entur.platform.examples.service.greet

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody

@Controller
class HelloWorldController {

    @GetMapping("/greet")
    @ResponseBody
    fun sayHello(
            @RequestParam(name = "name", required = false, defaultValue = "World") name: String
    ): Greeting {
        return Greeting("Sjallabais " + name)
    }
}
