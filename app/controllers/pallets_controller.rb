class PalletsController < ApplicationController
  before_action :set_pallet, only: [:show, :edit, :update, :destroy, :display]
  before_action :set_lists, only: [:new, :edit, :truck, :report]

  def index
    $cost_centers = ["NJ", "IL", "GA", "TX", "CO"]
    if session[:current_cc].present?
      pallets = Pallet.where(current_cc: session[:current_cc])
      @selected_ccc = session[:current_cc]
    else
      pallets = Pallet.where(current_cc: 'NJ')
      @selected_ccc = 'NJ'
    end
    @pallets = []
    pallets.each do |p|
      if p.current_cc != p.destination_cc
        @pallets.push(p)
      end
    end
  end

  def display

  end

  def show
    pdf = PalletLabel.new(@pallet)
    send_data pdf.render, filename: "Pallet #{@pallet.id.to_s}.pdf",
                          type: "application/pdf",
                          disposition: "inline"
  end

  def new
    @new = true
    @ict = false
    @due_date = Time.current.tomorrow.strftime('%Y-%m-%d')
    @pallet = Pallet.new
    @locations = []
    i = 0
    $locations.each do |l|
      if $ccs[i] == 'NJ' && $loctypes[i] != 'S'
        # initially load NJ non-staging locations
        @locations.push(l)
      end
      i += 1
    end
  end

  def edit
    @new = false
    @ict = @pallet.ict
    if @pallet.due_date
      @due_date = @pallet.due_date.strftime('%Y-%m-%d')
    else
      @due_date = ''
    end
    @locations = []
    i = 0
    $locations.each do |l|
      if $ccs[i] == @pallet.current_cc
        # load all locations for the current cc
        @locations.push(l)
      end
      i += 1
    end
  end

  def create
    i = 0
    nbr_of_pallets = pallets_params[:number_of_pallets].to_i
    pp = pallets_params
    pp[:current_cc] = pp[:origin_cc]
    while i < nbr_of_pallets
      i += 1
      @pallet = Pallet.new(pp)
      @pallet.save
      if i == 1
        pallet = @pallet
        pp[:number_of_pallets] = '1'
      end
    end
    redirect_to action: "display", id: pallet.id, notice: 'Pallet successfully created.'
  end

  def update
    respond_to do |format|
      if @pallet.update(pallets_params)
        # @pallet.current_location = @pallet.next_location
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

  def truck
    pallets = Pallet.all
    $jsccs = []
    $jspallets = []
    $jsdestinationccs = []
    $jscurrentlocations = []
    $jsvendorcodes = []
    ccpallets = []
    pallets.each do |p|
      if p.current_cc && p.current_cc != p.destination_cc
        # still in transit so collect information
        ccpallets.push(p.current_cc+p.id.to_s)
      end
    end
    ccpallets.sort!
    ccpallets.each do |c|
      $jspallets.push(c[2,c.length-2])
      $jsccs.push(c[0,2])
      p = Pallet.find_by id: c[2,c.length-2]
      if p
        $jsdestinationccs.push(p.destination_cc)
        $jscurrentlocations.push(p.current_location)
        $jsvendorcodes.push(p.vendor_code)
      else
        $jsdestinationccs.push('*')
        $jscurrentlocations.push('*')
        $jsvendorcodes.push('*')
      end
    end
    @pallets = []
    i = 0
    $jsccs.each do |c|
      if c == 'NJ' && !@pallets.include?($jspallets[i])
        p = Pallet.find($jspallets[i])
        if p.destination_cc.blank?
           dest = ' '
        else
           dest = p.destination_cc
        end
        if p.current_location.blank?
           curr = ' '
        else
           curr = p.current_location
        end
        if p.vendor_code.blank?
           vend = ' '
        else
           vend = p.vendor_code
        end
        @pallets.push($jspallets[i]+'-'+dest+'-'+curr+'-'+vend)
      end
      i += 1
    end
    @trucks = []
    i = 0
    $ccs.each do |c|
      if c == 'NJ' && $locations[i].start_with?('TRUCK') && !@trucks.include?($locations[i])
        @trucks.push($locations[i])
      end
      i += 1
    end
    @due_date = Time.current.tomorrow.strftime('%Y-%m-%d')
  end

  def selected
    params[:pallets].each do |p|
      if !p.empty?
        # this pallet has been selected to ride in the truck
        pallet_array = p.split("-")
        pallet = Pallet.find(pallet_array[0])
        pallet.next_location = params[:trucks]
        pallet.due_date = params[:due_date]
        pallet.save
      end
    end
    redirect_to pallets_path, notice: 'Pallets were successfully updated.'
  end

def report
  $report_trucks = []
  $jstrucks.each do |t|
    if !$report_trucks.include?(t)
      $report_trucks.push(t)
    end
  end
  $report_trucks.sort!
  @trucks = []
  @selected_truck = 1
  i = 1
  if !$pallets
    $pallets = []
    session[:selected_truck] = '1'
  end
  $report_trucks.each do |t|
    select_item = []
    select_item.push(t)
    select_item.push(i)
    @trucks.push(select_item)
    if i == session[:selected_truck].to_i
      @selected_truck = i
    end
    i += 1
  end
end

def chosen
  $pallets = Pallet.where(next_location: $report_trucks[params[:truck].to_i - 1])
  session[:selected_truck] = params[:truck]
  redirect_to action: "report"
end

def ccc
  session[:current_cc] = params[:current_cc]
  redirect_to action: "index"
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
        $dartagnan = []
        $dartagnan.push('DARTAGNAN')
        $vendors = []
        $jsvendors = []
        vendors.each do |v|
          if !v.buyer_code.blank? && !v.vend_name.include?("INACTIVE")
            $vendors.push(v.vend_name)
            $jsvendors.push(v.vend_name.gsub(' ', '~'))
          end
        end
        $vendors.sort!
        $vendors.unshift("BACKHAUL")
        locations = Locmsrt.all
        $locations = []
        $loctypes = []
        $ccs = []
        $jstrucks = []
        $jstrucksccs = []
        cclocations = []
        locations.each do |l|
          if (l.staging_flag == "1" || l.pack_flag == "1" || l.primary_dock == "1") && !l.location.blank? && !l.cost_ctr.blank?
            if l.staging_flag == "1"
              loctype = 'S'
            elsif l.pack_flag == "1"
              loctype = 'P'
            else
              loctype = 'D'
            end
            cclocation = l.cost_ctr + l.location + loctype
            if !cclocations.include?(cclocation)
              cclocations.push(cclocation)
            end
          end
        end
        cclocations.sort!
        cclocations.each do |c|
          location = c[2,c.length-3]
          $locations.push(location.gsub(' ', '~'))
          $ccs.push(c[0,2].gsub(' ', '~'))
          $loctypes.push(c[c.length-1,1].gsub(' ', '~'))
          if location.start_with?('TRUCK')
            # need to save truck locations and ccs
            $jstrucks.push(location)
            $jstrucksccs.push(c[0,2])
          end
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def pallets_params
      params.require(:pallet).permit(:origin_cc, :destination_cc, :current_location, :next_location, :vendor_code, :number_of_pallets, :due_date, :ict, :current_cc)
    end
end
