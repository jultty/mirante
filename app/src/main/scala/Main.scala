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
import scala.collection.mutable.ArrayBuffer

case class Account(name: String, username: String, email: String, password: String)
implicit val decoder: EntityDecoder[IO, Account] = jsonOf[IO, Account]

val accounts = ArrayBuffer.empty[Account]

object Main extends IOApp {
  val hello = HttpRoutes.of[IO] {
    case GET -> Root / "hello" / name =>
      Ok(s"Hello, $name")
    case req @ POST -> Root / "account" =>
      for {
        account <- req.as[Account]
        resp <- Ok(account.asJson)
      } yield (resp)
  }.orNotFound

  def run(args: List[String]): IO[ExitCode] =
    print_environment_properties
    EmberServerBuilder
      .default[IO]
      .withHost(ipv4"0.0.0.0")
      .withPort(port"6060")
      .withHttpApp(hello)
      .build
      .use(_ => IO.never)
      .as(ExitCode.Success)
}
