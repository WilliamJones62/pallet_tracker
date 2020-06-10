class PalletsController < ApplicationController
  before_action :set_pallet, only: [:show, :edit, :update, :destroy]
  before_action :set_lists, only: [:new, :edit]

  def index
    @pallets = Pallet.all
  end

  def show
    pdf = PalletLabel.new(@pallet)
    send_data pdf.render, filename: "Pallet #{@pallet.id.to_s}.pdf",
                          type: "application/pdf",
                          disposition: "inline"
  end

  def new
    @due_out = Time.current.tomorrow.strftime('%Y-%m-%d')
    @pallet = Pallet.new
  end

  def edit
    @due_out = @pallet.due_out.strftime('%Y-%m-%d')
  end

  def create
    i = 0
    nbr_of_pallets = pallets_params[:number_of_pallets].to_i
    while i < nbr_of_pallets
      i += 1
      @pallet = Pallet.new(pallets_params)
      @pallet.save
      if i == 1
        pallet = @pallet
      end
    end
    redirect_to pallet_path(pallet, format: "pdf"), notice: 'Pallets successfully created.'
  end

  def update
    respond_to do |format|
      if @pallet.update(pallets_params)
        @pallet.current_location = @pallet.next_location
        @pallet.save
        format.html { redirect_to pallets_path notice: 'Pallet was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pallet.destroy
    respond_to do |format|
      format.html { redirect_to pallets_url, notice: 'Pallet was successfully deleted.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pallet
      @pallet = Pallet.find(params[:id])
    end

    def set_lists
      if !$locations
        # need to set up global list of CCs, locations and vendors
        $cost_centers = ["NJ", "IL", "GA", "TX", "CO"]
        vendors = Apvndmstr.all
        $vendors = []
        vendors.each do |v|
          if !v.buyer_code.blank? && !v.vend_name.include?("INACTIVE")
            $vendors.push(v.vend_name)
          end
        end
        $vendors.sort!
        locations = Locmsrt.all
        $locations = []
        locations.each do |l|
          if (l.staging_flag == "1" || l.pack_flag == "1" || l.primary_dock == "1") && !l.location.blank? && !$locations.include?(l.location)
            $locations.push(l.location)
          end
        end
        $locations.sort!
      end
    end

    # Only allow a list of trusted parameters through.
    def pallets_params
      params.require(:pallet).permit(:origin_cc, :destination_cc, :current_location, :next_location, :vendor_code, :number_of_pallets, :due_out)
    end
end
