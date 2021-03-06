module Dhl::Bcs::V2
  class Receiver

    # a location is one of Address, Packstation, Postfiliale or ParcelShop
    PROPERTIES = %i(name communication location).freeze

    attr_accessor(*PROPERTIES)

    def self.build(name: nil, **attributes)
      communication = Communication.build(attributes)
      location =
        if attributes.key?(:packstation_number)
          Packstation
        elsif attributes.key?(:postfilial_number)
          Postfiliale
        elsif attributes.key?(:parcel_shop_number)
          ParcelShop
        else
          Address
        end.build(attributes)
      new(attributes.merge(name: name, communication: communication, location: location))
    end

    def initialize(**attributes)
      attributes.each do |property, value|
        send("#{property}=", value) if PROPERTIES.include?(property)
      end
    end

    def to_soap_hash
      {
        'cis:name1' => name,
        'Communication' => communication.to_soap_hash,
        location.class.name.split('::').last => location.to_soap_hash
      }
    end

  end
end
