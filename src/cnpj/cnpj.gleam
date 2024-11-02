import cnpj/generator
import cnpj/validation

/// Validates a given CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
/// 
/// This function performs a flexible validation on the provided CNPJ string.
/// Flexible validation allows for some leniency in the format of the input string.
/// 
/// # Examples
/// 
/// ```gleam
/// import utilsbr/cnpj
/// 
/// assert True = cnpj.validate("12.345.678/0001-95")
/// assert False = cnpj.validate("12.345.678/0001-00")
/// ```
/// 
/// @param cnpj The CNPJ number to be validated as a string.
/// @return A boolean indicating whether the CNPJ is valid.
pub fn validate(cnpj: String) -> Bool {
  validation.handle_flexible_validation(cnpj)
}

/// Strictly validates a given CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
/// 
/// This function performs a strict validation on the provided CNPJ string.
/// Strict validation requires the input string to adhere strictly to the expected format.
/// 
/// # Examples
/// 
/// ```gleam
/// import utilsbr/cnpj
/// 
/// assert True = cnpj.strict_validate("12.345.678/0001-95")
/// assert False = cnpj.strict_validate("12345678000195")
/// ```
/// 
/// @param cnpj The CNPJ number to be validated as a string.
/// @return A boolean indicating whether the CNPJ is valid.
pub fn strict_validate(cnpj: String) -> Bool {
  validation.handle_strict_validation(cnpj)
}

/// Generates a new CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
/// 
/// This function generates a new, valid CNPJ number. The generated CNPJ can be formatted
/// or unformatted based on the input parameter.
/// 
/// # Examples
/// 
/// ```gleam
/// import utilsbr/cnpj
/// 
/// let formatted_cnpj = cnpj.generate(True)
/// let unformatted_cnpj = cnpj.generate(False)
/// 
/// assert formatted_cnpj == "12.345.678/0001-95"
/// assert unformatted_cnpj == "12345678000195"
/// ```
/// 
/// @param formatted A boolean indicating whether the generated CNPJ should be formatted.
/// @return A string representing the generated CNPJ.
pub fn generate(formatted: Bool) -> String {
  generator.generate(formatted)
}
