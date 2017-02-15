class ChargesController < ApplicationController
  after_action :upgrade_user_to_premium, only: [:create]
  after_action :downgrade_to_standard, only: [:destroy]
  
  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "BigMoney Membership - #{current_user.email}",
      amount: Amount.default
    }
  end

  def create
    # Creates a Stripe Customer object, for assoicating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
    
    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer: customer.id, 
      amount: Amount.default,
      description: "BigMoney Membership - #{current_user.email}",
      currency: 'usd'
    )
    
    if charge["paid"]
      :upgrade_user_to_premium
    end
    
    flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    redirect_to root_path
    
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end
  
  def destroy
    downgrade_to_standard
    
    if current_user.role == 0
      flash[:notice] = "\"Your account was successfully downgraded."
      redirect_to root_path
    else
      flash.now[:alert] = "There was an error downgrading your account."
      redirect_to new_charge_path
    end
    
  end
  
  
  private
  
  def upgrade_user_to_premium
    current_user.role = 1
    current_user.save
  end
  
  def downgrade_to_standard
    current_user.role = 0
    current_user.save
  end
  
  
end
