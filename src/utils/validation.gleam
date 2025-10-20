/// Calculates a verification digit using modulo 11 algorithm
/// This is used for both CPF and CNPJ validation
pub fn calculate_verification_digit_mod11(remainder: Int) -> Int {
  case remainder {
    0 | 1 -> 0
    _ -> 11 - remainder
  }
}
