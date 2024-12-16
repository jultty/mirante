type form_data = { "email": string, "password": string }

type fields

type credentials = {
  @as("email") user_email: string,
  @as("token") user_token: string
}
