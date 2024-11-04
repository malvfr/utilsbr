import cnpj/cleaner
import cnpj/generator
import cnpj/validation
import utils/format

const invalid_cnpj_message = "Invalid CNPJ"

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
/// assert True = cnpj.strict_validate("84.980.771/0001-82")
/// assert False = cnpj.strict_validate("    84.980.771/0001-82  ")
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
/// assert formatted_cnpj == "84.980.771/0001-82"
/// assert unformatted_cnpj == "84980771000182"
/// ```
/// 
/// @param formatted A boolean indicating whether the generated CNPJ should be formatted.
/// @return A string representing the generated CNPJ.
pub fn generate(formatted: Bool) -> String {
  generator.generate(formatted)
}

/// Strips formatting from a given CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
/// 
/// This function removes any formatting characters from the provided CNPJ string,
/// leaving only the numeric digits.
/// 
/// # Examples
/// 
/// ```gleam
/// import utilsbr/cnpj
/// 
/// assert "12345678000195" = cnpj.strip("12.345.678/0001-95")
/// ```
/// 
/// @param cnpj The CNPJ number to be stripped of formatting as a string.
/// @return A string representing the unformatted CNPJ.
pub fn strip(cnpj: String) -> Result(String, String) {
  let cleaned_cnpj = cleaner.clean(cnpj)

  case validate(cleaned_cnpj) {
    True -> Ok(cleaned_cnpj)
    False -> Error(invalid_cnpj_message)
  }
}

/// Formats a given CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
/// 
/// This function applies the standard CNPJ formatting to the provided numeric string.
/// The input string must contain exactly 14 digits.
/// 
/// # Examples
/// 
/// ```gleam
/// import utilsbr/cnpj
/// 
/// assert "12.345.678/0001-95" = cnpj.format("12345678000195")
/// ```
/// 
/// @param cnpj The CNPJ number to be formatted as a string.
/// @return A string representing the formatted CNPJ.
pub fn format(cnpj: String) -> Result(String, String) {
  let cleaned_cnpj = cleaner.clean(cnpj)

  case validate(cleaned_cnpj) {
    True -> Ok(format.format_cnpj(cleaned_cnpj))
    False -> Error(invalid_cnpj_message)
  }
}
