require('sinatra')
  require('sinatra/reloader')
  require('./lib/stylist')
  require('./lib/client')
  also_reload('lib/**/*.rb')
  require("pg")
  require("pry")

  DB = PG.connect({:dbname => "hair_salon"})


  get("/") do
    @stylists = Stylist.all()
    @clients=Client.all()
    erb(:index)
  end

  post("/stylists") do
    name = params.fetch("name")
    address = params.fetch("address")
    stylist = Stylist.new({:name => name, :address => address, :id => nil})
    stylist.save()
    @stylists=Stylist.all()
    @clients=Client.all()
    erb(:index)
  end

  get("/stylists/:id") do
    @stylist = Stylist.find(params.fetch("id").to_i())
    erb(:stylist)
  end

  get("/clients/:id") do
    @client = Client.find(params.fetch("id").to_i())
    erb(:client)
  end

  post("/clients") do
    first_name = params.fetch("first_name")
    last_name = params.fetch("last_name")
    stylist_id = params.fetch("stylist_id").to_i()
    @stylist = Stylist.find(stylist_id)
    @client = Client.new({:first_name => first_name, :last_name => last_name, :stylist_id => stylist_id, :id => nil})
    @client.save()
    erb(:stylist)
  end

  get("/stylists/:id/edit") do
    @stylist = Stylist.find(params.fetch("id").to_i())
    erb(:stylist_edit)
  end

  patch("/stylists/:id") do
    name = params.fetch("name")
    address = params.fetch("address")
    @stylist = Stylist.find(params.fetch("id").to_i())
    @stylist.update({:name => name, :address => address})
    erb(:stylist)
  end

  delete("/stylists/:id") do
    @stylist = Stylist.find(params.fetch("id").to_i())
    @stylist.delete()
    @stylists = Stylist.all()
    @clients=Client.all()
    erb(:index)
  end

  patch("/clients/:id") do
    first_name = params.fetch("first_name")
    last_name = params.fetch("last_name")
    @client = Client.find(params.fetch("id").to_i())
    @client.update({:first_name => first_name, :last_name => last_name})
    erb(:client)
  end

  delete("/clients/:id") do
    @client = Client.find(params.fetch("id").to_i())
    @client.delete()
    @stylists = Stylist.all()
    @clients=Client.all()
    erb(:index)
  end

  get("/clients/:id/edit") do
    @client = Client.find(params.fetch("id").to_i())
    erb(:client_edit)
  end
