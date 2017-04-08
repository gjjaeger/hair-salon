class Stylist
    attr_reader(:name, :address, :id)

    define_method(:initialize) do |attributes|
      @name = attributes.fetch(:name)
      @address = attributes.fetch(:address)
      @id = attributes.fetch(:id)
    end

    define_singleton_method(:all) do
      returned_stylists = DB.exec("SELECT * FROM stylists;")
      stylists = []
      returned_stylists.each() do |stylist|
        name = stylist.fetch("name")
        address=stylist.fetch("address")
        id = stylist.fetch("id").to_i()
        stylists.push(Stylist.new({:name => name, :address => address, :id => id}))
      end
      stylists
    end

    define_method(:save) do
      result = DB.exec("INSERT INTO stylists (name, address) VALUES ('#{@name}','#{@address}') RETURNING id;")
      @id = result.first().fetch("id").to_i()
    end

    define_method(:==) do |another_stylist|
      self.name().==(another_stylist.name()).&(self.address().==(another_stylist.address())).&(self.id().==(another_list.id()))
    end

    define_singleton_method(:find) do |id|
      found_stylist = nil
      Stylist.all().each() do |stylist|
        if stylist.id().==(id)
          found_stylist = stylist
        end
      end
      found_stylist
    end

    define_method(:clients) do
      stylist_clients = []
      clients = DB.exec("SELECT * FROM clients WHERE stylist_id = #{self.id()};")
      clients.each() do |client|
        first_name = client.fetch("first_name")
        last_name = client.fetch("last_name")
        stylist_id = client.fetch("stylist_id").to_i()
        stylist_clients.push(Client.new({:first_name => first_name, :last_name => last_name, :stylist_id => stylist_id}))
      end
      stylist_clients
    end

    define_method(:update) do |attributes|
      name = attributes.fetch(:name)
      address = attributes.fetch(:address)
      if name != ""
        @name = name
      end
      if address != ""
        @address = address
      end
      @id = self.id()
      DB.exec("UPDATE stylists SET name = '#{@name}', address= '#{@address}' WHERE id = #{@id};")
    end

    define_method(:delete) do
      DB.exec("DELETE FROM stylists WHERE id = #{self.id()};")
      DB.exec("DELETE FROM clients WHERE stylist_id = #{self.id()};")
    end
  end
