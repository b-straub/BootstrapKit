//
//  Form.swift
//  BootstrapKit
//
//  Created by Mats Mollestad on 17/07/2019.
//

import HTMLKit

public protocol FormInput : AttributeNode {}

extension Input : FormInput {}
extension Select : FormInput {}
extension TextArea : FormInput {}

public struct FormGroup : StaticView {

    let label: Label
    let input: FormInput
    let optionalContent: View?

    public init(_ label: Label, _ input: FormInput, @HTMLBuilder optionalContent: () -> View) {
        self.label = label
        self.input = input
        self.optionalContent = optionalContent()
    }

    public init(_ label: Label, _ input: FormInput) {
        self.label = label
        self.input = input
        self.optionalContent = nil
    }

    public init(label: View, _ input: FormInput, @HTMLBuilder optionalContent: () -> View) {
        self.label = Label { label }
        self.input = input
        self.optionalContent = optionalContent()
    }

    public init(label: View, _ input: FormInput) {
        self.label = Label { label }
        self.input = input
        self.optionalContent = nil
    }

    public var body: View {
        guard let inputId = input.id else {
            fatalError("Missing an id attribute on an Input in a FormGroup")
        }
        return Div {
            label.for(inputId)
            input.class("form-control")
            IF(optionalContent != nil) {
                optionalContent ?? ""
            }
        }.class("form-group")
    }
}

extension AttributeNode {
    var id: View? { attributes.first(where: { $0.attribute == "id" })?.value }
}


public protocol InputGroupAddons : View {}

public struct InputGroup : StaticView {

    let prepend: InputGroupAddons?
    let append: InputGroupAddons?
    let input: Input
    let wrapInput: Bool

    public var body: View {
        Div {
            IF(prepend != nil) {
                Div {
                    prepend ?? None() // Workaround for concrearte type
                }.class("input-group-prepend")
            }

            input.class("form-controll")

            IF(append != nil) {
                Div {
                    append ?? None()
                }.class("input-group-append")
            }
        }
            .class("input-group")
            .class(IF(wrapInput == false) { " flex-nowrap" })
    }


    struct None: StaticView {
        var body: View { "" }
    }

    public struct Text: StaticView {

        let text: String

        public init(_ text: String) {
            self.text = text
        }

        public var body: View {
            Span {
                text
            }.class("input-group-text")
        }
    }

    typealias ButtonAddon = Button
    typealias DropdownAddon = Dropdown
}

extension InputGroup.None : InputGroupAddons {}
extension InputGroup.Text : InputGroupAddons {}
extension InputGroup.ButtonAddon : InputGroupAddons {}
extension InputGroup.DropdownAddon : InputGroupAddons {}
