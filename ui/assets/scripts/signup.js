const form = document.getElementById('account_creation_form')
const dialog = document.getElementById('user_dialog')

async function sign_up_handler(event) {
  event.preventDefault();
  dialog.innerText = ''

  const form_data = Object.fromEntries(new FormData(form));
  let response
  let response_json

  try {

    response = await fetch('http://localhost:3031/rpc/signup', {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(form_data),
    })

    response_json = await response.json()

  } catch(error) {

    dialog.innerText = 'Erro na requisição'
    console.log(error)
    return

  }

  if (response.status == 200 || response.status == 201) {

    const credentials = {
      "email": response_json.email,
      "token": response_json.token,
    }

    sessionStorage.setItem("mirante_credentials", JSON.stringify(credentials))
    const stored_credentials = JSON.parse(sessionStorage.getItem("mirante_credentials"))
    console.log("Stored Email: " + stored_credentials.email)
    console.log("Stored Token: " + stored_credentials.token)
    dialog.innerText = 'Conta criada com sucesso'

  }

  else if (response.status == 409)
    dialog.innerText = 'Uma conta com este email já existe'
  else
    dialog.innerText = `Erro ${response.status} ao criar conta`

}

form.addEventListener('submit', sign_up_handler)
