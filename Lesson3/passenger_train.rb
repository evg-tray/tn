class PassengerTrain < Train

  def self.type
    "Пассажирский"
  end

  def hitch_wagon(wagon)
    if wagon.class == PassengerWagon
      super
    end
  end
end
