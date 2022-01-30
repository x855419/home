import { ComponentFixture, TestBed } from '@angular/core/testing';

import { IntroductionToCiphershopComponent } from './introduction-to-ciphershop.component';

describe('IntroductionToCiphershopComponent', () => {
  let component: IntroductionToCiphershopComponent;
  let fixture: ComponentFixture<IntroductionToCiphershopComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ IntroductionToCiphershopComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(IntroductionToCiphershopComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
