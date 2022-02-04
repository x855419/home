import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InitialPrivatePurchaseAvailableComponent } from './initial-private-purchase-available.component';

describe('InitialPrivatePurchaseAvailableComponent', () => {
  let component: InitialPrivatePurchaseAvailableComponent;
  let fixture: ComponentFixture<InitialPrivatePurchaseAvailableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ InitialPrivatePurchaseAvailableComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(InitialPrivatePurchaseAvailableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
