# Finn
Junior Mobile Technical Challenge

A description of your solution:
I decided to show the advertisements in a TableView with the name(the name could be cut if it is too big), location, ad-type and image; if the user click on the cell it will prompt a new view of the ad with a bigger picture, the complete name, price ad a button to add or delete an ad from the favorite list.
The SecondView could seems a little empty but my idea was to show better the image of the ad, as well as, setting up the ads so in the future they could display more details that the ones given in the JSON, like a link (I tried the links in the JSON and they seem down, that why I didn't add them).
For the favorite, they are being saved into a DataCore. I choose DataCore over other ways of persist data because of the potential size of the favorite list and the performance.
The FavoriteView show the ads save in a list and they could be deleted one by one or all at the same time.


If there’s anything you feel particularly proud of:
This is the first time I create a iOS application, it could sound cliche nevertheless, I'm really proud that this application is first one and it works
I also put all my focus on smooth perfomance, things like creating a Cache so the images are only download ones and the correct ones are display everytime, saving internat data and improving the loading times


If there’s anything you believe could have been done better:
I need to mention that I dont own a mac, for the majority of the programming I was using a virtual machine, so in some occations I encountered visual error that I wasnt able to pin down as virtual machine or codes errors (for example: the button merge when clicking two times so they hide, some times the last button did not hide or the favorite button do not show the correct color if they are deleted in the Favorite View), I tried to solve them but at no avail.
The "assets", the static of the application I sure could be better; for example, the favorite button could be a heart or the cells of the TableView could look better or even I could use a complete different structure better than the TableView that I didnt know


What else you could have done with more time:
Another thing that I would love to add if I had more time were some functionalities, that unfortunately, I had to scrap:
- A more robust sort
- A search bar that could work in combination with the sort
- I though that I could add an authentication step, creating different accounts and using an online serves like Firebase, however, it started to look too time consuming when combining the offline favorite list capability.
