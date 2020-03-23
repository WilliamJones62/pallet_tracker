class PalletLabel < Prawn::Document
  def initialize(pallet)
    super(top_margin: 80)
    @i = 0
    @pallet = pallet
    while @i < @pallet.number_of_pallets
      @pallet_number = @pallet.id + @i
      pallet_number
      origin_cc
      destination_cc
      vendor
      pallet_date
      barcode
      @i += 1
      if @i < @pallet.number_of_pallets
        start_new_page
      end
    end
  end

  def pallet_number
    move_down 20
    text "Pallet: "+@pallet_number.to_s, size: 30, style: :bold
  end

  def origin_cc
    move_down 20
    text "Origin: "+@pallet.origin_cc, size: 30, style: :bold
  end

  def destination_cc
    move_down 20
    text "Destination: "+@pallet.destination_cc, size: 30, style: :bold
  end

  def vendor
    move_down 20
    text "Vendor: "+@pallet.vendor_code, size: 30, style: :bold
  end

  def pallet_date
    move_down 20
    text "Date: "+@pallet.created_at.strftime("%e %b %Y"), size: 30, style: :bold
  end

  def barcode
    move_down 20
    barcode = Barby::Code39.new @pallet_number.to_s
    barcode.annotate_pdf(self)
  end

end
