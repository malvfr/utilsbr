import cpf/cleaner
import cpf/generator
import cpf/validation
import utils/format

const invalid_cpf_message = "Invalid CPF"

/// Validates a given CPF (Cadastro de Pessoas Físicas) number using flexible validation rules.
///
/// This function checks if the provided CPF number is valid according to flexible validation rules.
/// Flexible validation allows for some leniency in the format of the CPF number.
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cpf
///
/// let valid_cpf = cpf.validate("161.803.571-10")
/// assert True = valid_cpf
/// 
/// let valid_cpf = cpf.validate("  161.803.571-10  ")
/// assert True = valid_cpf
/// 
/// let valid_cpf = cpf.validate("161*803*571*10")
/// assert True = valid_cpf
///
/// let invalid_cpf = cpf.validate("151.803.571-10")
/// assert False = invalid_cpf
/// ```
///
/// @param cpf A string representing the CPF number to be validated.
/// @return A boolean indicating whether the CPF number is valid.
pub fn validate(cpf: String) -> Bool {
  validation.handle_flexible_validation(cpf)
}

/// Validates a given CPF (Cadastro de Pessoas Físicas) number using strict validation rules.
///
/// This function checks if the provided CPF number is valid according to strict validation rules.
/// Strict validation requires the CPF number to adhere to a specific format and checksum.
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cpf
///
/// let valid_cpf = cpf.strict_validate("873.220.050-15")
/// assert True = valid_cpf
///
/// let invalid_cpf = cpf.strict_validate("  873.220.050-15  ")
/// assert False = invalid_cpf
/// ```
///
/// @param cpf A string representing the CPF number to be validated.
/// @return A boolean indicating whether the CPF number is valid.
pub fn strict_validate(cpf: String) -> Bool {
  validation.handle_strict_validation(cpf)
}

/// Generates a random CPF (Cadastro de Pessoas Físicas) number.
/// The generated CPF number is valid according to flexible validation rules.
/// # Examples
/// ```gleam
/// import utilsbr/cpf
/// 
/// let cpf = cpf.generate(True)
/// > "873.220.050-15"
/// 
/// let cpf = cpf.generate(False)
/// > "87322005015"
/// ```
/// @param formatted A boolean indicating whether the generated CPF number should be formatted.
/// @return A string representing the generated CPF number.
pub fn generate(formatted: Bool) -> String {
  generator.generate(formatted)
}

/// Formats a CPF number by removing any non-numeric characters and applying the standard CPF format.
///
/// This function takes a CPF number as a string, cleans it by removing any non-numeric characters,
/// and then formats it according to the standard CPF format.
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cpf
/// let formatted_cpf = cpf.format("123.456.789-09")
/// assert formatted_cpf == "123.456.789-09"
/// ```
///
/// @param cpf The CPF number as a string.
/// @return The formatted CPF number as a string.
pub fn format(cpf: String) -> Result(String, String) {
  let cleaned_cpf = cleaner.clean(cpf)

  case validate(cleaned_cpf) {
    True -> Ok(format.format_cpf(cleaned_cpf))
    False -> Error(invalid_cpf_message)
  }
}

/// Strips a CPF number of any non-numeric characters.
///
/// This function takes a CPF number as a string and removes any non-numeric characters,
/// returning only the numeric characters as a string.
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cpf
/// let stripped_cpf = cpf.strip("123.456.789-09")
/// assert stripped_cpf == "12345678909"
/// ```
///
/// @param cpf The CPF number as a string.
/// @return The stripped CPF number as a string containing only numeric characters.
pub fn strip(cpf: String) -> Result(String, String) {
  let cleaned_cpf = cleaner.clean(cpf)

  case validate(cleaned_cpf) {
    True -> Ok(cleaned_cpf)
    False -> Error(invalid_cpf_message)
  }
}
