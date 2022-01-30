import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AboutDaoTokenDistributionAndInvestorRecruitmentComponent } from './about-dao-token-distribution-and-investor-recruitment.component';

describe('AboutDaoTokenDistributionAndInvestorRecruitmentComponent', () => {
  let component: AboutDaoTokenDistributionAndInvestorRecruitmentComponent;
  let fixture: ComponentFixture<AboutDaoTokenDistributionAndInvestorRecruitmentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AboutDaoTokenDistributionAndInvestorRecruitmentComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AboutDaoTokenDistributionAndInvestorRecruitmentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
