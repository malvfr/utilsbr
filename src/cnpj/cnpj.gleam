import cnpj/cleaner
import cnpj/generator
import cnpj/validation

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
/// Works with both numeric and alphanumeric CNPJs.
///
/// For numeric CNPJs, accepts formatted (XX.XXX.XXX/XXXX-XX) or unformatted (XXXXXXXXXXXXXX).
/// For alphanumeric CNPJs, accepts formatted (XX.XXX.XXX/XXXX-XX) or unformatted (XXXXXXXXXXXXXX).
/// Letters in alphanumeric CNPJs are case-insensitive.
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cnpj
///
/// // Numeric CNPJs
/// assert True = cnpj.strict_validate("84.980.771/0001-82")
/// assert True = cnpj.strict_validate("84980771000182")
///
/// // Alphanumeric CNPJs
/// assert True = cnpj.strict_validate("12.ABC.345/01DE-35")
/// assert True = cnpj.strict_validate("12ABC34501DE35")
/// assert True = cnpj.strict_validate("12.abc.345/01de-35")
///
/// // Invalid: spaces or wrong separators
/// assert False = cnpj.strict_validate("    84.980.771/0001-82  ")
/// assert False = cnpj.strict_validate("12*ABC*345*01DE*35")
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
/// returning only alphanumeric characters (for alphanumeric CNPJs) or numeric digits
/// (for numeric CNPJs). Automatically detects the CNPJ type.
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cnpj
///
/// assert Ok("12345678000195") = cnpj.strip("12.345.678/0001-95")
/// assert Ok("12ABC34501DE35") = cnpj.strip("12.ABC.345/01DE-35")
/// ```
///
/// @param cnpj The CNPJ number to be stripped of formatting as a string.
/// @return A Result with the unformatted CNPJ string or an error message.
pub fn strip(cnpj: String) -> Result(String, String) {
  let cleaned_cnpj = cleaner.clean_auto(cnpj)

  case validate(cleaned_cnpj) {
    True -> Ok(cleaned_cnpj)
    False -> Error(invalid_cnpj_message)
  }
}

/// Formats a given CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
///
/// This function applies the standard CNPJ formatting to the provided string.
/// Automatically detects whether the CNPJ is numeric or alphanumeric and formats accordingly.
/// - Numeric CNPJs: "12.345.678/0001-95"
/// - Alphanumeric CNPJs: "12.ABC.345/01DE-35"
///
/// # Examples
///
/// ```gleam
/// import utilsbr/cnpj
///
/// assert Ok("12.345.678/0001-95") = cnpj.format("12345678000195")
/// assert Ok("12.ABC.345/01DE-35") = cnpj.format("12ABC34501DE35")
/// ```
///
/// @param cnpj The CNPJ number to be formatted as a string.
/// @return A Result with the formatted CNPJ string or an error message.
pub fn format(cnpj: String) -> Result(String, String) {
  let cleaned_cnpj = cleaner.clean_auto(cnpj)

  case validate(cleaned_cnpj) {
    True -> Ok(cleaner.format_auto(cleaned_cnpj))
    False -> Error(invalid_cnpj_message)
  }
}
