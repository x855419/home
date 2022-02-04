import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { BlogComponent } from './components/blog/blog.component';
import { LandingPageComponent } from './components/landing-page/landing-page.component';
import { AboutDaoTokenDistributionAndInvestorRecruitmentComponent } from './components/posts/about-dao-token-distribution-and-investor-recruitment/about-dao-token-distribution-and-investor-recruitment.component';
import { InitialPrivatePurchaseAvailableComponent } from './components/posts/initial-private-purchase-available/initial-private-purchase-available.component';
import { IntroductionToCiphershopComponent } from './components/posts/introduction-to-ciphershop/introduction-to-ciphershop.component';
import { WhitepaperComponent } from './components/whitepaper/whitepaper.component';

const routes: Routes = [
  {
    path: '',
    component: LandingPageComponent
  },
  {
    path: 'whitepaper',
    component: WhitepaperComponent
  },
  {
    path: 'blog',
    component: BlogComponent
  },
  {
    path: 'blog/introduction-to-ciphershop',
    component: IntroductionToCiphershopComponent
  },
  {
    path: 'blog/about-dao-token-distribution-and-investor-recruitment',
    component: AboutDaoTokenDistributionAndInvestorRecruitmentComponent
  },
  {
    path: 'blog/initial-private-purchase-available',
    component: InitialPrivatePurchaseAvailableComponent
  },
  {
    path: '**',
    redirectTo: '',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
