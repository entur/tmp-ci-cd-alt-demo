package org.entur.platform.examples.service.actuator

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.test.context.TestPropertySource

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestPropertySource(properties = ["management.port=0"])
class ActuatorTests {

    @Autowired
    lateinit var restTemplate: TestRestTemplate

    @Value("\${local.management.port}")
    var managementPort: Int = 0

    @Test
    fun `health endpoint should return "UP" when app has started`() {
        val responseEntity = restTemplate.getForEntity("http://localhost:" + managementPort + "/actuator/health", Map::class.java)
        assertThat(responseEntity.statusCodeValue).isEqualTo(200)
        assertThat(responseEntity.body!!["status"]).isEqualTo("UP")
    }

}
