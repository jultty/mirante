open Browser

let clearChildren = (id: string) => {

  let parent = Option.getExn(
    getElementById(doc, id),
    ~message="[clearChildren] parent not found"
  )

  while Option.isSome(parent.lastElementChild) {

    removeChild(
      parent,
      Option.getExn(parent.lastElementChild,
        ~message="[clearChildren] child not found"))

  }
}
