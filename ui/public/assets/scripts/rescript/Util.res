let to_sentence_title_case = (original: string): string => {
  let first_character = String.charAt(original, 0)
  String.replace(original, first_character, String.toUpperCase(first_character))
}
