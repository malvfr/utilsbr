//import cnpj/generator
import cnpj/validation

pub fn validate(cnpj: String) -> Bool {
  validation.handle_flexible_validation(cnpj)
}

pub fn strict_validate(cnpj: String) -> Bool {
  validation.handle_strict_validation(cnpj)
}
// pub fn generate(formatted: Bool) -> String {
//   generator.generate(formatted)
// }
