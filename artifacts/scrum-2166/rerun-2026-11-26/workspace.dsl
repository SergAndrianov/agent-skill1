workspace "ПлатиДом" "Автоплатёж с лимитом суммы" {
    !impliedRelationships false

    model {
        client = person "Клиент" "Авторизованный пользователь мобильного банка."
        accrualSource = softwareSystem "ГИС ЖКХ" "Внешний источник начислений ЖКУ. Учебное допущение A-01." "External"
        processing = softwareSystem "Карточный процессинг" "Принимает оплату и возвращает итог. Учебное допущение A-12." "External"

        platidom = softwareSystem "ПлатиДом" "Раздел мобильного банка для регулярных начислений." {
            mobile = container "Мобильное приложение банка" "Настройка автоплатежа и просмотр результатов." "iOS / Android" "MobileDevicePortrait"
            api = container "API ПлатиДома" "Проверяет доступ, управляет правилами, обрабатывает автоплатежи и уточняет результаты." "Java / Spring Boot"
            db = container "База данных ПлатиДома" "Хранит привязки, правила, снимки начислений, попытки и причины пропуска." "PostgreSQL" "Database"
        }

        client -> mobile "Выбирает привязку и источник, задаёт лимит и подтверждает согласие. Меняет, отключает, смотрит исход" "UI"
        mobile -> api "Читает свои привязки, правила и исходы" "HTTPS / JSON" "ReadAutopay"
        mobile -> api "Сохраняет правило по ID привязки, источнику, лимиту и согласию. Отключает по ID привязки" "HTTPS / JSON" "WriteAutopay"
        api -> db "Читает привязки. Читает и пишет правила, снимки, попытки и пропуски" "SQL / JDBC"
        api -> accrualSource "Запрашивает начисления по поставщику и лицевому счёту" "API ГИС ЖКХ · контракт уточнить"
        api -> processing "Условно проверяет доступность источника и средства на сумму" "Запрос / ответ · контракт уточнить" "PaymentCheck"
        api -> processing "Передаёт ID начисления, источник оплаты, сумму, валюту и ключ попытки" "Платёжный запрос · контракт уточнить" "PaymentCommand"
        api -> processing "Условно уточняет статус по сохранённому ключу попытки" "Запрос / ответ · контракт уточнить" "PaymentStatus"
    }

    views {
        container platidom "AutoPaymentLimit" {
            include client mobile api db accrualSource processing
            title "C4 · Уровень 2 · ПлатиДом — Автоплатёж с лимитом суммы"
            description "SCRUM-2166. Условные связи требуют подтверждения внешнего контракта."
            autoLayout lr 250 145
        }

        styles {
            element "Person" {
                shape Person
                background #183153
                color #ffffff
            }
            element "Container" {
                background #1d5681
                color #ffffff
            }
            element "MobileDevicePortrait" {
                shape MobileDevicePortrait
            }
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #526276
                color #ffffff
            }
            relationship "ReadAutopay" {
                style dashed
                position 30
            }
            relationship "WriteAutopay" {
                style solid
                position 70
            }
            relationship "PaymentCheck" {
                style dashed
                position 22
            }
            relationship "PaymentCommand" {
                style solid
                position 50
            }
            relationship "PaymentStatus" {
                style dashed
                position 78
            }
        }
    }
}
