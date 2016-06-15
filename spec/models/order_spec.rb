require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to(:user) }
  it { should respond_to(:items) }
  it { should respond_to(:order_items) }

  scenario "it can create order items" do
    order = Order.create
    item = Item.create(name: "thing", description: "great", price: "10")
    cart = Cart.new({ "#{item.id}" => 1 })

    order.create_order_items(cart)

    expect(OrderItem.count).to eq 1
    expect("thing").to eq(order.items.last.name)
  end

  scenario "it counts all with a given status" do
    create_list(:order, 3)
    create(:order, status: 1)
    create(:order, status: 2)
    create(:order, status: 3)

    expect(Order.total(0)).to eq 3
    expect(Order.total(1)).to eq 1
    expect(Order.total(2)).to eq 1
    expect(Order.total(3)).to eq 1
  end

  scenario "it returns all order objects with a given status" do
    create_list(:order, 3)
    create(:order, status: 1)
    create(:order, status: 2)
    create(:order, status: 3)

    expect(Order.objects(0).count).to eq 3
    expect(Order.objects(1).count).to eq 1
    expect(Order.objects(2).count).to eq 1
    expect(Order.objects(3).count).to eq 1
  end

  scenario "it tells whether status is editable" do
    default_order = create(:order)
    paid_order = create(:order, status: 1)
    cancelled_order = create(:order, status: 2)
    completed_order = create(:order, status: 3)

    expect(default_order.editable_status?).to eq true
    expect(paid_order.editable_status?).to eq true
    expect(cancelled_order.editable_status?).to eq false
    expect(completed_order.editable_status?).to eq false
  end

  scenario "it changes status based on current status" do
    default_order = create(:order)
    paid_order = create(:order, status: 1)

    expect(default_order.status_options).to eq(["ordered", "paid", "cancelled"])
    expect(paid_order.status_options).to eq(["paid", "completed", "cancelled"])
  end
end
