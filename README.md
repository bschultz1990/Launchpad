# Launchpad
This is a work-related app to help relieve copy and paste strain and help you focus on getting work done.
This was made special for the hard-working online team at Earth Sense Energy Systems. You guys rock! ♥️

# Disclaimer
This software comes with no warranty. If you hit the wrong button, you will make Evosus spaz out. At best, I've had to close some random dialog boxes.  At worst, I've had a payment entered prematurely. This software is optional. If you intend to use it, please be aware of the risks.

This software copies and pastes sensitive data such as names, email addresses, and phone numbers. However, it does not store this data. After you close Launchpad, it forgets the order data entirely. [Here is my code]() so you can verify.

# Installation
Grab the release from the [Releases page](). Unzip wherever you'd like to put it and run.

Prerequisites
- [Google Chrome](https://www.google.com/chrome/)
- ShipWorks
- Evosus

# Setup
Open up ShipWorks. Right-click on your column headers.

![header](https://user-images.githubusercontent.com/19655298/153038265-2889c3d1-15ef-445f-8c1d-5b9ce18be3e5.PNG)

Make sure you have the following headers **in this exact order:**

![columns](https://user-images.githubusercontent.com/19655298/153036256-bff0f04d-9cbc-4f33-b77b-1c01981e98d5.PNG)

You may add other column headers afterwards, but the first 21 must look _exactly_ like the picture above. Otherwise, Launchpad will be very confused.

## Tweaking Addresses
Before importing an order from ShipWorks, make sure its address is correctly formatted. In order to make lasting changes that Launchpad will also understand, DO NOT change anything on the Shipping panel to the right as you may be used to:

![address_bar](https://user-images.githubusercontent.com/19655298/153064409-9ccc7802-b488-487d-b69e-a253382b2127.PNG)

Instead, double-click on the order, hit "Address" and then "Edit." Make your changes here. Be sure to validate the address and take any suggestions before hitting "OK" and saving your progress:

![address_edit](https://user-images.githubusercontent.com/19655298/153071346-a28a6f0d-c0d3-4467-a116-566fa5265055.PNG)

After this, your Shipping panel will also say it needs to validate your changes. It does not. If you've modified the address by double-clicking, you can safely ignore this message.

![address_validated](https://user-images.githubusercontent.com/19655298/153071542-216b0263-4528-4a85-a55f-3b70b538b436.PNG)

> **Note:** Unfortunately, this is more involved than tweaking the address on the Shipping panel. Since it can be jarring to flip between address fixing and order entry, I suggest tweaking a handful of addresses first, then entering those orders afterwards.

# Usage
Launchpad stays on top of all other windows. Open it and move it wherever it's out of the way. When you're ready, hit the "Import Order" button.

![launchpad](https://user-images.githubusercontent.com/19655298/153051081-228d4c71-55d0-428d-8168-2dd71ec584c9.PNG)

Here, Launchpad will be looking for your order info. Head to ShipWorks, right-click on the order you want to copy, select "Copy," then "Copy Row." Alternatively, you can left-click on an order and hit `Ctrl+c`.

![order_copy](https://user-images.githubusercontent.com/19655298/153060818-51e896a0-1f82-4d55-a5ed-f65572e65a38.PNG)

Right-click on the text field in Launchpad's window and hit "Paste." Alternatively, you can left-click on this text field and hit `Ctrl+v`.

![order_paste](https://user-images.githubusercontent.com/19655298/153061685-80f84f59-8a73-4723-a47a-49f838e5a32f.PNG)

Click "OK".

From here, Launchpad will look different depending on what platform your order is from. From top to bottom is Pellethead.com, Amazon.com, eBay.com, and Walmart.com. We'll walk through each in turn:

![order_all](https://user-images.githubusercontent.com/19655298/153092069-572f8898-91a4-40b2-b35b-bcf0f5ac3499.jpg)

## Pellethead.com
Here is an overview of what these buttons do. Details are below that.

![order_pellethead](https://user-images.githubusercontent.com/19655298/153092503-3c6541ce-3592-438f-a829-56fc2321ff17.png)

- **Lookup Cst.:** Launches order page in Chrome. Looks up customer address in Evosus.
- **Enter Cst.** If the customer doesn't exist in Evosus, enters their information in a "New Customer" window automatically.
- **$** Copy and paste whatever payment memo the customer used. Launchpad will dynamically create a payment button for you afterwards.
- **Payment (AZ, Card, PayPal)** *Use only when Evosus payment screen is visible!* Inputs your payment memo, selects "Pay in Full," selects appropriate payment method, waits for your to push `Enter`, speeds through the payment confirmation screens, and allows you to select which items to invoice.

### Lookup Cst
Make sure you have Chrome open. It'll yell at you if you don't. Launchpad will open a new browser tab then flip back to Evosus to look up the customer by address.

### Enter Cst.

![customer_address](https://user-images.githubusercontent.com/19655298/153304667-24491275-2309-4540-9165-098dfa0f2953.png)

On this screen, make sure all the appropriate fields get filled. Launchpad will also select an appropriate customer interest, contact type, and gender for you in the background, so all you have to do is press enter to speed through the Interest and Attributes tabs.

### $
Copy and paste the payment memo the customer used. Launchpad will create an appropriate payment button based off your input. You don't have to get it exactly. Launchpad will cut out extraneous words or spaces for you. *Important:* If they paid via Amazon Payments, make sure you use the memo from the note that says, "Status: Closed."

### Payment (AZ, Card, PayPal)

> **Only use this when the Payment screen is visible, as pictured above.**

Fills in the above fields and waits for 10 seconds. Make sure all the fields are filled in correctly. Within 10 seconds, hit "Submit Payment" or just hit `Enter`. Launchpad will speed through to the "Invoice Items" screen where you can select what you want to invoice and the stock site you want to invoice from.
