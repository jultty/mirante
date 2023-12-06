import cats.effect._
import cats.effect.unsafe.implicits.global
import org.http4s._
import org.http4s.dsl.io._
import org.http4s.implicits._
import org.http4s.circe._
import org.http4s.ember.server._
import io.circe._
import io.circe.generic.auto._
import io.circe.syntax._
import io.circe.literal._
import com.comcast.ip4s._

def hello_json(name: String): Json =
  json"""{"hello": $name}"""

case class Hello(name: String)
case class User(name: String)

object Main extends IOApp {
  val hello = HttpRoutes.of[IO] {
    case GET -> Root / "hello" / name =>
      Ok(hello_json(name))
    case GET -> Root / "user" / name =>
      Ok(User(name).asJson)
  }.orNotFound

  def run(args: List[String]): IO[ExitCode] =
    print_environment_properties
    EmberServerBuilder
      .default[IO]
      .withHost(ipv4"0.0.0.0")
      .withPort(port"8080")
      .withHttpApp(hello)
      .build
      .use(_ => IO.never)
      .as(ExitCode.Success)
}
