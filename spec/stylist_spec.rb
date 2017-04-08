require('rspec')
  require('pg')
  require('stylist')
  require('client')
  require('spec_helper')

  describe(Stylist) do
    describe(".all") do
      it("starts off with no stylists") do
        expect(Stylist.all()).to(eq([]))
      end
    end

    describe("#name") do
      it("tells you its name") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        expect(stylist.name()).to(eq("Best stylist in town"))
      end
    end

    describe("#id") do
      it("sets its ID when you save it") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist.save()
        expect(stylist.id()).to(be_an_instance_of(Fixnum))
      end
    end

    describe("#save") do
      it("lets you save stylists to the database") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist.save()
        expect(Stylist.all()).to(eq([stylist]))
      end
    end

    describe("#==") do
      it("is the same stylist if it has the same name") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylis2 = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        expect(list1).to(eq(list2))
      end
    end

    describe(".find") do
     it("returns a stylist by its ID") do
       stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
       stylist.save()
       stylist2 = Stylist.new({:name => "Worst stylist in town", :address => "33 Lockhart Road", :id => nil})
       stylist2.save()
       expect(List.find(test_list2.id())).to(eq(test_list2))
     end
    end

    describe("#clients") do
      it("returns an array of clients for that stylist") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist.save()
        test_client = Client.new({:first_name => "Brian", :last_name=>"Law", :stylist_id => stylist.id()})
        test_client.save()
        test_client2 = Client.new({:first_name => "Richard", :last_name=>"Ng", :stylist_id => stylist.id()})
        test_client2.save()
        expect(stylist.clients()).to(eq([test_client, test_client2]))
      end
    end

    describe("#update") do
      it("lets you update stylists in the database") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist.save()
        stylist.update({:name => "Decent stylist"})
        expect(stylist.name()).to(eq("Decent stylist"))
      end
    end

    describe("#delete") do
      it("lets you delete a stylist from the database") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist.save()
        stylist2 = Stylist.new({:name => "Stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist2.save()
        stylist.delete()
        expect(Stylist.all()).to(eq([stylist2]))
      end
      it("deletes a stylist's clients from the database") do
        stylist = Stylist.new({:name => "Best stylist in town", :address => "31 Lockhart Road", :id => nil})
        stylist.save()
        test_client = Client.new({:first_name => "Brian", :last_name=>"Law", :stylist_id => stylist.id()})
        test_client.save()
        test_client2 = Client.new({:first_name => "Richard", :last_name=>"Ng", :stylist_id => stylist.id()})
        test_client2.save()
        stylist.delete()
        expect(Client.all()).to(eq([]))
      end
    end
  end
