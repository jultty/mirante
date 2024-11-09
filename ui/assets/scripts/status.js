status_element = document.getElementById('status')

const status_object = {
  "version": "",
  "user": "",
  "error": "",
}

async function setStatus(_) {

  let response_json

  try {
    const response = await fetch('http://localhost:3031/version?current=is.true')
    response_json = await response.json()
    status_object.version = "Mirante " + response_json["0"].tag
  } catch(error) {
    console.log(error)
    status_object.error = 'Erro de conexão: "' + error + '" com resposta "' + response_json + '"'
  }

  const stored_credentials = sessionStorage.getItem("mirante_credentials")

  try {
    if (stored_credentials == undefined | stored_credentials == 'undefined')
      status_object.user = '[Não autenticado]'
    else if (stored_credentials) {
      console.log(stored_credentials)
      let credentials_json = JSON.parse(stored_credentials)
      status_object.user = '[' + credentials_json.email + ']'
    }
  } catch(error) {
    console.log(error)
    status_object.error = 'Erro de autenticação: "' + error
  }

  if (status_object.error)
    status_element.innerText = ('Erro: ' + status_object.error)
  else if (status_object.user && status_object.version)
    status_element.innerText = ('Conectado: ' + status_object.version + ' ' + status_object.user)
  else if (status_object.version)
    status_element.innerText = ('Conectado: ' + status_object.version)
  else
    status_element.innerText = 'Carregando...'

}

window.addEventListener("load", setStatus)
