import gleam/regexp

/// Cleans a given CPF string by removing all non-numeric characters.
///
/// This function takes a CPF string as input and uses a regular expression
/// to remove any characters that are not digits (0-9). The cleaned CPF
/// string, containing only numeric characters, is then returned.
///
/// # Examples
///
/// ```gleam
/// let cleaned_cpf = clean("123.456.789-09")
/// assert cleaned_cpf == "12345678909"
/// ```
///
/// # Arguments
///
/// * `cpf` - A string representing the CPF to be cleaned.
///
/// # Returns
///
/// A new string containing only the numeric characters from the input CPF.
pub fn clean(cpf: String) {
  let assert Ok(only_numbers_regex) =
    regexp.compile("[^0-9]", regexp.Options(False, False))

  regexp.replace(each: only_numbers_regex, in: cpf, with: "")
}
