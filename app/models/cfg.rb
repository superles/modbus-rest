class Cfg
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  include ActiveModel::Serializers::JSON

  attr_accessor(
      :host,
      :port,
      :slave,
      :coil,
      :coil_addr,
      :coil_val,
      :discrete_input,
      :discrete_input_addr,
      :discrete_input_val,
      :holding_register,
      :holding_register_addr,
      :holding_register_val,
      :input_register,
      :input_register_addr,
      :input_register_val
  )

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end

  def loadfile
    @cfg= File.read(File.join(Rails.root,'db','modbus.json'));
    @conf=self
    @conf.from_json(@cfg,false)
    @conf
  end

end
