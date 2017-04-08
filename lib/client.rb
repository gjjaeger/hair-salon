require("pry")
class Client
    attr_reader(:id, :first_name, :last_name, :list_id)

    define_method(:initialize) do |attributes|
      @first_name = attributes.fetch(:first_name)
      @last_name = attributes.fetch(:last_name)
      @stylist_id = attributes.fetch(:stylist_id)
      @id = attributes[:id]
    end

    define_singleton_method(:all) do
      returned_clients = DB.exec("SELECT * FROM clients;")
      clients = []
      returned_clients.each() do |client|
        first_name = client.fetch("first_name")
        last_name = client.fetch("last_name")
        stylist_id = client.fetch("stylist_id").to_i() # The information comes out of the database as a string.
        id=client.fetch("id").to_i()
        clients.push(Client.new({:first_name => first_name, :last_name => last_name, :stylist_id => stylist_id, :id => id}))
      end
      clients
    end

    define_method(:save) do
      result=DB.exec("INSERT INTO clients (first_name, last_name, stylist_id) VALUES ('#{@first_name}', '#{@last_name}', #{@stylist_id}) RETURNING id;")
      @id = result.first().fetch("id").to_i()
    end

    define_method(:==) do |another_client|
      self.first_name().==(another_client.last_name()).&(self.last_name().==(another_task.last_name())).&(self.stylist_id().==(another_client.stylist_id())).&(self.id().==(another_client.id()))
    end

    define_method(:update) do |attributes|
      first_name = attributes.fetch(:first_name)
      last_name = attributes.fetch(:last_name)
      if first_name != ""
        @first_name = first_name
      end
      if last_name != ""
        @last_name = last_name
      end
      @id = self.id()
      DB.exec("UPDATE clients SET first_name = '#{@first_name}', last_name= '#{@last_name}' WHERE id = #{@id};")
    end

    define_singleton_method(:find) do |id|
      found_client = nil
      Client.all().each() do |client|
        if client.id().==(id)
          found_client = client
        end
      end
      found_client
    end

    define_method(:delete) do
      DB.exec("DELETE FROM clients WHERE id = #{self.id()};")
    end

    define_method(:stylists) do
      stylist_clients = []
      stylistids = DB.exec("SELECT stylist_id FROM clients WHERE id = #{self.id()};")
      stylistids.each() do |stylist|
        result = DB.exec("SELECT * FROM stylists WHERE id=#{stylist.fetch("stylist_id")}")
        name = result.first().fetch("name")
        address = result.first().fetch("address")
        id = result.first().fetch("id").to_i
        stylist_clients.push(Stylist.new({:name => name, :address => address, :id => id}))
      end
      stylist_clients
    end
  end
