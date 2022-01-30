import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ReactiveFormsModule } from '@angular/forms';

import { MatIconModule } from '@angular/material/icon'; 

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LandingPageComponent } from './components/landing-page/landing-page.component';
import { BlogComponent } from './components/blog/blog.component';
import { IntroductionToCiphershopComponent } from './components/posts/introduction-to-ciphershop/introduction-to-ciphershop.component';
import { AboutDaoTokenDistributionAndInvestorRecruitmentComponent } from './components/posts/about-dao-token-distribution-and-investor-recruitment/about-dao-token-distribution-and-investor-recruitment.component';
import { WhitepaperComponent } from './components/whitepaper/whitepaper.component';

@NgModule({
  declarations: [
    AppComponent,
    LandingPageComponent,
    BlogComponent,
    IntroductionToCiphershopComponent,
    AboutDaoTokenDistributionAndInvestorRecruitmentComponent,
    WhitepaperComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    ReactiveFormsModule,
    MatIconModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
