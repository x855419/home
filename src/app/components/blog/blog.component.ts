import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-blog',
  templateUrl: './blog.component.html',
  styleUrls: ['./blog.component.css']
})

export class BlogComponent implements OnInit {

  searchForm: FormGroup = this.fb.group({
    query: ['', Validators.required]
  });
  searchTerm: string = '';
  noSearchResults: boolean = false;

  categoriesOpen: boolean = false;
  searchOpen: boolean = false;

  categories: string[] = ['All', 'Announcements', 'Project Updates', 'Platform', 'Technology', 'Tutorials'];
  actualCategory: string = 'All';

  filteredArticles: boolean = false;
  searchedArticles: boolean = false;

  languages: string[] = ['en', 'us'];
  actualLanguage: string = 'es';

  articles: any[][] = [
    [
      {
        url: './about-dao-token-distribution-and-investor-recruitment',
        img: './assets/articles-logos/es/arbolesdenavidad_338,11x338,11px-100.jpg',
        category: 'Announcements',
        title: 'About CSHOP token distribution and investor recruitment.',
        description: 'Details on the initial distribution of CSHOP tokens, with detailed graphs and investor attraction phases. Available to all users with limited stock.',
        date: '27 January, 2022'
      },
      {
        url: './introduction-to-ciphershop',
        img: './assets/articles-logos/es/elcorazondelagua_338,11x338,11px-100.jpg',
        category: 'Announcements',
        title: 'Introduction to CipherShop.',
        description: 'Discover what CipherShop is, the components, its functionality, thus premiering its release.',
        date: '27 January, 2022'
      }
    ]
  ];

  articlesShowed: any[] = [];

  pages: number = this.articles.length;
  pagesIndex: number = 0;
  
  constructor(
    private fb: FormBuilder
  ) { }
  
  ngOnInit(): void {
    for (let i = 0; i <= this.pagesIndex; i++) {
      let page = this.articles[i];
      for (let article of page) {
        this.articlesShowed.push(article);
      }
    }
  }

  loadMore(): void {
    if (this.pages !== (this.pagesIndex + 1)) {
      this.pagesIndex++;
      let page = this.articles[this.pagesIndex];
      for (let article of page) {
        this.articlesShowed.push(article);
      }
    }
  }

  filterByCategory(category: string): void {
    this.searchedArticles = false;
    this.noSearchResults = false;
    if (category === this.actualCategory) {
      this.categoriesOpen = false;
      return;
    }
    this.actualCategory = category;
    if (this.actualCategory === this.categories[0]) {
      this.filteredArticles = false;
      this.articlesShowed = [];
      this.pagesIndex = 0;
      for (let i = 0; i <= this.pagesIndex; i++) {
        let page = this.articles[i];
        for (let article of page) {
          this.articlesShowed.push(article);
        }
      }
    }
    else {
      this.filteredArticles = true;
      let list: any[] = [];
      for (let i = 0; i < this.pages; i++) {
        let page = this.articles[i];
        for (let article of page) {
          if (article.category === this.actualCategory) {
            list.push(article);
          }
        }
      }
      this.articlesShowed = list;
    }
    this.categoriesOpen = false;
  }
  
  searchContent(): void {
    if (this.searchForm.valid) {
      this.searchTerm = this.searchForm.get('query')?.value;
      this.searchForm.get('query')?.patchValue('');
      this.filteredArticles = true;
      this.searchedArticles = true;
      this.actualCategory = 'All';
      let list: any[] = [];
      for (let i = 0; i < this.pages; i++) {
        let page = this.articles[i];
        for (let article of page) {
          if (article.category.includes(this.searchTerm) || article.title.includes(this.searchTerm) || article.description.includes(this.searchTerm)) {
            list.push(article);
          }
        }
      }
      this.articlesShowed = list;
      if (this.articlesShowed.length === 0) {
        this.noSearchResults = true;
      } else {
        this.noSearchResults = false;
      }
      this.searchOpen = false;
    }
  }

  clearSearchContent(): void {
    this.actualCategory = 'All';
    this.pagesIndex = 0;
    let list: any[] = [];
    for (let i = 0; i <= this.pagesIndex; i++) {
      let page = this.articles[i];
      for (let article of page) {
        list.push(article);
      }
    }
    this.articlesShowed = list;
    this.noSearchResults = false;
    this.searchedArticles = false;
    this.filteredArticles = false;
  }

}
