package in.devbratpradhan.portfolio.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class HomeController {

    @Value("${web3forms.access_key}")
    private String web3formsKey;

    @GetMapping({"","/","/home"})
    public String showHomePage(Model model){
        model.addAttribute("web3formsKey", web3formsKey);
        return "home";
    }
}