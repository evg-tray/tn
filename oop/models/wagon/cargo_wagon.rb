class CargoWagon < Wagon
  attr_reader :volume, :busy_volume

  def initialize(number, volume)
    super(number)
    @volume = volume
    validate_volume!(@volume)
    @busy_volume = 0
  end

  def take_cargo(volume)
    validate_volume!(volume)
    message = 'Указанное количество груза не поместится в вагоне.'
    raise message if free_volume < volume
    @busy_volume += volume
  end

  def free_volume
    @volume - @busy_volume
  end

  def to_s
    "#{@number}, грузовой, свободно: #{free_volume}, занято: #{busy_volume}"
  end

  private

  def validate_volume!(volume)
    raise 'Неверно указан объем!' unless volume.is_a? Numeric
    raise 'Объем должен быть больше 0!' unless volume > 0
  end
end
