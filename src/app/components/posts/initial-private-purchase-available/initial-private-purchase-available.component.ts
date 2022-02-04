import { Component, OnDestroy, OnInit } from '@angular/core';

@Component({
  selector: 'app-initial-private-purchase-available',
  templateUrl: './initial-private-purchase-available.component.html',
  styleUrls: ['./initial-private-purchase-available.component.css']
})

export class InitialPrivatePurchaseAvailableComponent implements OnInit, OnDestroy {

  endTime: Date = new Date("2022-06-14");

  totalTime: string = ""

  interval: any;

  constructor() { }

  ngOnInit(): void {
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
    let seconds: number = Math.ceil(difference / 1000);
    let days: number = Math.ceil(seconds / (3600 * 24));
    seconds %= (3600 * 24);
    let hours: number = Math.ceil(seconds / 3600);
    seconds %= 3600;
    let minutes: number = Math.ceil(seconds / 60);
    seconds %= 60;
    this.totalTime = days + ':' + hours + ':' + minutes + ':' + seconds;
  }

}
