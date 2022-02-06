import { Component, OnDestroy, OnInit } from '@angular/core';

@Component({
  selector: 'app-initial-private-purchase-available',
  templateUrl: './initial-private-purchase-available.component.html',
  styleUrls: ['./initial-private-purchase-available.component.css']
})

export class InitialPrivatePurchaseAvailableComponent implements OnInit, OnDestroy {

  totalCSHOPToken: number = 2_000_000;

  soldCSHOPToken: number = 0;

  progressBarValue: number = 0;

  endTime: Date = new Date("2022-06-14");

  totalTime: string = ""

  interval: any;

  availaiblePurchase: boolean = true;

  constructor() { }

  ngOnInit(): void {
    this.progressBarValue = (1 - ((this.totalCSHOPToken - this.soldCSHOPToken) / this.totalCSHOPToken)) * 100;
    this.refreshDate();
    this.interval = setInterval(() => {
      this.refreshDate();
    }, 1000);
  }

  ngOnDestroy(): void {
      if (this.interval) {
        clearInterval(this.interval);
      }
  }
  
  refreshDate(): void {
    let date: Date = new Date();
    let difference: number = this.endTime.getTime() - date.getTime();
    if (difference < 0) {
      this.totalTime = '0:0:0:0';
      if (this.interval) {
        clearInterval(this.interval);
      }
      this.availaiblePurchase = false; 
      return;
    }
    let seconds: number = Math.ceil(difference / 1000);
    let days: number = Math.ceil(seconds / (3600 * 24));
    seconds %= (3600 * 24);
    let hours: number = Math.ceil(seconds / 3600);
    seconds %= 3600;
    let minutes: number = Math.ceil(seconds / 60);
    seconds %= 60;
    this.totalTime = days + ':' + hours + ':' + minutes + ':' + seconds;
  }

  priceFormat(number: number): string {
    if (number >= 1_000 && number < 1_000_000) {
      return number.toString().substring(0, 3) + 'k';
    }
    else if (number >= 1_000_000) {
      return number.toExponential(2).substring(0, 4) + 'M';
    }
    else {
      return number.toString();
    }
  }

}
