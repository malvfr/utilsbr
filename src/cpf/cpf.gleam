import cpf/generator
import cpf/validation

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
/// let valid_cpf = cpf.strict_validate("123.456.789-09")
/// assert True = valid_cpf
///
/// let invalid_cpf = cpf.strict_validate("123.456.789-00")
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
/// > "123.456.789-00"
/// 
/// let cpf = cpf.generate(False)
/// > "12345678900"
/// ```
/// @param formatted A boolean indicating whether the generated CPF number should be formatted.
/// @return A string representing the generated CPF number.
pub fn generate(formatted: Bool) -> String {
  generator.generate(formatted)
}
