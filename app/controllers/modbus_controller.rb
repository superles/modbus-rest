class ModbusController < ApplicationController


  def index
  end



  def write_float(host, port, slave_uid, reg_num, reg_val, reg_type)

    if reg_type=='input_registers'
      reg_type='multiple_registers'
    end

    if reg_type=='input_register'
      reg_type='single_register'
    end


    if reg_type=='holding_register'
      reg_type='single_register'
    end

      ModBus::TCPClient.new(host, port) do |cl|
        cl.with_slave(slave_uid) do |slave|

           reg_val=Array([Float(reg_val.gsub('_', '.'))])

            slave.send("write_#{reg_type}", reg_num.first, reg_val.from_32f)


        end
      end


  end

  def read_float(host, port, slave_uid, reg_num, reg_type)


    if reg_type.to_s=="single_register" or reg_type.to_s=="multiple_registers"
      reg_type = :input_registers
    end


    res=false


    ModBus::TCPClient.new(host, port) do |cl|
      cl.with_slave(slave_uid) do |sl|

        res=sl.send("read_#{reg_type}", reg_num.first, reg_num.count)




      end
    end
    return res.to_32f

  end


  def write_int(host, port, slave_uid, reg_num, reg_val,reg_type)


    if reg_type=='discrete_input'
      reg_type='coil'
    end

    if reg_type=='discrete_inputs' or reg_type=='coils'
      reg_type='multiple_coils'
    end

    if reg_type=='holding_register'
      reg_type='single_register'
    end

    ModBus::TCPClient.new(host, port) do |cl|
      cl.with_slave(slave_uid) do |sl|

        sl.send("write_#{reg_type}", reg_num.first, reg_val)
       


      end
    end

  end

  def read_int(host, port, slave_uid, reg_num,reg_type)

    value=false

    ModBus::TCPClient.new(host, port) do |cl|

      cl.with_slave(slave_uid) do |sl|

        value = sl.send("read_#{reg_type}", reg_num.first, reg_num.count)


      end
    end
    return value
  end

  def get_reg(str=params[:reg])


      if str.to_s.split(',').count==0
        reg_num=Array([str.to_i])
      else
        reg_num=Array.new
        str.split(',').each do |item|
          reg_num.push(item.to_i)
        end
      end



    reg_num

  end

  def get_val(str=params[:val])


    if str.to_s.split(',').count==0
      reg_val=Array([str.to_i])
    else
      reg_val=Array.new
      str.split(',').each do |item|
        reg_val.push(item.to_i)
      end
    end



    reg_val

  end

  def parse


    reg_num=self::get_reg



    @reg_num=reg_num

    @host=params[:host].gsub('_', '.')
    @port=params[:port].to_i
    @slave_uid=params[:slave].to_i
    @reg_type=params[:reg_type].to_s
    @var_type=params[:var_type].to_s
    if params[:val]==:none

      if params[:var_type]=='int'
        @value= self::read_int(@host, @port, @slave_uid, @reg_num,@reg_type)
      elsif params[:var_type]=='float'
        @value= self::read_float(@host, @port, @slave_uid, @reg_num, @reg_type)
      else
        @value=false
      end
    else


      if params[:var_type]=='int'
        @reg_val=params[:val].to_i
       self::write_int(@host, @port, @slave_uid, @reg_num,@reg_val,@reg_type)
       @value=self::read_int(@host, @port, @slave_uid, @reg_num,@reg_type)
      elsif params[:var_type]=='float'
        @reg_val=params[:val].to_s

       self::write_float(@host, @port, @slave_uid, @reg_num,@reg_val, @reg_type)
       @value= self::read_float(@host, @port, @slave_uid, @reg_num, @reg_type)
      else
        @value=false
      end
    end


    render :json => @value.to_json


  end

  def userconfig
    @conf= Cfg.new
    @conf.loadfile

  end



end
