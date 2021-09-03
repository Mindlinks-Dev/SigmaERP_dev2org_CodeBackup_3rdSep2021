.slds-backdrop {
  height: 94%;
}
.slds-fade-in-open {
  height: 94%;
}
.material-icons {
  font-family: "Material Icons";
  font-weight: normal;
  font-style: normal;
  font-size: 20px;
  line-height: 1;
  letter-spacing: normal;
  text-transform: none;
  display: inline-block;
  white-space: nowrap;
  word-wrap: normal;
  direction: ltr;
  -webkit-font-smoothing: antialiased;
}

.floating-chat1 {
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  bottom: 0px;
  right: 14px;
  width: 50px;
  height: 50px;
  transform: translateY(70px);
  transition: all 250ms ease-out;
  border-radius: 50%;
  opacity: 0;
  background-color: #dc2f2f;
  background-repeat: no-repeat;
  background-attachment: fixed;
}
.floating-chat1.enter {
  transform: translateY(0);
  opacity: 1;
  box-shadow: 0px 0px 8px 5px rgba(0, 0, 0, 0.12),
    0px 1px 9px 1px rgba(0, 0, 0, 0.14);
}

/*Help Menu*/
.trialWindowClass {
  /*transition: all 2s linear;*/
  box-shadow: 0px 0px 8px 5px rgba(0, 0, 0, 0.12),
    0px 1px 9px 1px rgba(0, 0, 0, 0.14);
  background: aliceblue;
  position: absolute;
  top: 83px;
  right: 67px;
  z-index: 5;
  border-radius: 10px 10px 10px 10px;
  transition: all 0.5s linear;
  transition-property: opacity, width, height;
}
.trialWindowClass.collapse {
  opacity: 0;
  width: 0px;
  height: 0%;
}
.trialWindowClass.expand {
  opacity: 1;
  width: 250px;
  height: auto;
}
.fontClass {
  font-family: arial;
  font-size: 13px;
  color: #fff;
  margin: 0 0 0.5em 1em;
  padding: 0 1em 0 0;
}
.fontClassHeader1 {
  font-family: arial;
  font-size: 14.5px;
  color: #fcb3ab;
  margin: 0 0 0.5em 1em;
  padding: 0 1em 0 0;
}
.not-active {
  pointer-events: none;
  color: lightslategray;
}

@font-face {
  font-family: "Material Icons";
  font-style: normal;
  font-weight: 400;
  src: url(https://fonts.gstatic.com/s/materialicons/v48/flUhRq6tzZclQEJ-Vdg-IuiaDsNc.woff2)
    format("woff2");
}

@media screen and (max-width:800px) {
.lafPageHost{overflow: scroll !important;
} 