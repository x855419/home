import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ReactiveFormsModule } from '@angular/forms';

import { MatIconModule } from '@angular/material/icon'; 
import { MatProgressBarModule } from '@angular/material/progress-bar';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './components/home/home.component';
import { BlogComponent } from './components/blog/blog.component';
import { IntroductionToCiphershopComponent } from './components/posts/introduction-to-ciphershop/introduction-to-ciphershop.component';
import { AboutDaoTokenDistributionAndInvestorRecruitmentComponent } from './components/posts/about-dao-token-distribution-and-investor-recruitment/about-dao-token-distribution-and-investor-recruitment.component';
import { WhitepaperComponent } from './components/whitepaper/whitepaper.component';
import { InitialPrivatePurchaseAvailableComponent } from './components/posts/initial-private-purchase-available/initial-private-purchase-available.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    BlogComponent,
    IntroductionToCiphershopComponent,
    AboutDaoTokenDistributionAndInvestorRecruitmentComponent,
    WhitepaperComponent,
    InitialPrivatePurchaseAvailableComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    ReactiveFormsModule,
    MatIconModule,
    MatProgressBarModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
