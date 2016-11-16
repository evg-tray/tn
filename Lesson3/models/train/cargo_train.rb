require_relative "../wagon/cargo_wagon"
class CargoTrain < Train
  TYPE = "Грузовой"
  TYPE_WAGON = CargoWagon

end
