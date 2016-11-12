class CargoTrain < Train

  def self.type
    "Грузовой"
  end

  def hitch_wagon(wagon)
    if wagon.class == CargoWagon
      super
    end
  end
end
