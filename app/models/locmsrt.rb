class Locmsrt < ApplicationRecord
  establish_connection "e21prod".to_sym
  self.table_name = "locmstr"
end
