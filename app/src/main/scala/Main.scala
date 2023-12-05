import org.http4s._
import org.http4s.dsl.io._
import org.http4s.implicits._
import org.http4s.ember.server._
import cats.effect._
import com.comcast.ip4s._

object Main extends IOApp {
  val hello = HttpRoutes.of[IO] {
    case GET -> Root / "hello" / name =>
      Ok(s"Hello, $name.")
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
